# Uploading files with Paperclip & S3

## Sign up for AWS S3

If you want your users to upload files to your application, you are
going to need a place to store these files. As Heroku server instances
can be added and deleted on the fly, these instances themselves do not
offer persistent storage. Amazon AWS S3 is one of the major cloud
storage services which offers us a place to reliably store data.

To get started, [sign up](http://aws.amazon.com/s3/) for an Amazon AWS
account.

Go to S3 in your
[AWS Console](https://console.aws.amazon.com/console/home).

Click on "Create Bucket" and give this new bucket a name. You may want
to create two separate buckets. One for development, and one for
production.

While signed into Amazon AWS, you also want to retrieve your `AWS
Access Key ID` and your `AWS Secret Access Key`. You can find them on
the site under
[Security Credentials](https://portal.aws.amazon.com/gp/aws/securityCredentials)

## Setting up Paperclip & S3

To be able to identify and resize images, Paperclip requires
ImageMagick to be installed.

To check whether you have ImageMagick already install run `which
convert`. If this gives you a path, you're golden.

To install ImageMagick using Homebrew use the following command.

    brew install imagemagick

Next, add the Paperclip and AWS-SDK gems to your Gemfile.

    gem "paperclip"
    gem "aws-sdk"

Bundle install your gems.

Now we want to configure our Paperclip settings.

In your `production.rb` and `development.rb` environment config files,
add the following code, adding your bucket and security
credentials. You may want to use different buckets for production and
development.

    config.paperclip_defaults = {
      :storage => :s3,
      :s3_credentials => {
        :bucket => YOUR_BUCKET_NAME,
        :access_key_id => YOUR_ACCESS_KEY_ID,
        :secret_access_key => YOUR_SECRET_ACCESS_KEY
      }
    }

## Add a Paperclip to your model

Say we have a Pirate model and we want each Pirate instance to have a
beard_photo file attached to it.

First we want the `beard_photo` attribute to be accessible in our
model.

    class Pirate < ActiveRecord::Base
      attr_accessible :beard_photo
    end

Next we want to add the Paperclip functionality to the
model. Paperclip gives us the `has_attached_file` method to configure
this.

    class Pirate < ActiveRecord::Base
      attr_accessible :beard_photo
  
      has_attached_file :beard_photo, :styles => {
        :big => "600x600>",
        :small => "50x50#"
      }
    end

You can specify multiple styles for your images, specifying different
sizes in the format `(width)x(height)(resize method)`. The `>` scales
the image proportionally to fit within the specified size. The `#`
scales the image to fill up the whole specified size and then crops
the part that sticks out.

If you're not storing images, but other file types, you can omit the
specifying of styles.

Though we use S3 to store our actual image files in the cloud, we need
to add extra columns to our database table to remember where the image
was stored, as well as some meta data Paperclip requires.

So let's add a migration. You can generate this migration running
`rails g paperclip pirate beard_photo` or you can write this by
hand. You should end up with the following.

    class AddAttachmentBeardPhotoToPirates < ActiveRecord::Migration
      def self.up
        change_table :pirates do |t|
          t.attachment :beard_photo
        end
      end

      def self.down
        drop_attached_file :pirates, :beard_photo
      end
    end

Run `rake db:migrate` and you're good to go!

## Upload and display images in your views

In your forms add `<%= f.file_field :beard_photo %>` to create a file
upload field (assuming you're using the Rails `form_for` helper). Your
`<form>` tag needs to have the `enctype="multipart/form-data"`
attribute set in order to submit binary files. Rails' `form_for`
helper will be smart enough to add this for you when a file field is
present.

You can access the image file url using `@pirate.beard_photo.url`. You
can give the `.url` method a symbol corresponding to the styles you
set up in your model, like: `@pirate.beard_photo.url(:small)`.

To display your image, use the image tag helper.

    <%= image_tag @pirate.beard_photo.url(:big) %>

## Resources

1. https://github.com/thoughtbot/paperclip
2. http://aws.amazon.com/s3/
3. https://devcenter.heroku.com/articles/paperclip-s3


