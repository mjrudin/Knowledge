CSS
===

Selectors
---------

### Basic Selectors

Elements can be directly accessed and styled based on their markup in HTML:

* Element: `li { ... }`
* ID: `#element-id { ... }`
* Class: `.class-name { ... }`
* Attributes: `a[href="appacademy.io"] { ... }`

### Relational/Pseudo Selectors

Elements can be accessed based on their relationship to other elements on the page. For example, you may want to style `<li>`s that are nested in a `<ul>` differently than `<li>`s in a `<ol>` element:

* Descendents (all): `ul li { ... }`
* Children (direct descendents): `ul > li { ... }`
* Siblings: `li.class_name + li { ... }`

CSS provides a number of 'pseduo-selectors' that make it easier to style based on UI state. A few examples:

* Hover: `a:hover { ... }`
* Visited: `a:visited { ... }`
* Focus: `input:focus { ... }`
* First Letter: `p:first-letter { ... }`
* First Child: `li:first-child { ... }`

Similar to a 'pseudo-selector', CSS provides 'pseudo-content' options so that you can inject content either before or after a certain element. These selectors are only useful if you specify a content property in the styling (`content: "..."`):

* Before: `div:before { ... }`
* After: `div:after { ... }`

### CSS3 Selectors

The CSS3 specification contains a large number of new relational/pseudo selectors to try out and take advantage of. Make sure to check sites like [Can I Use](http://www.caniuse.com) for browser compatibility, though:

* N'th Child: `li:nth-child(n) { ... } `
* First of Type: `h3:first-of-type { ... } `
* Disabled: `button:disabled { ... } `
* Checked: `input:checked { ... } `
* Preceded By (general siblings): `li.class_name ~ li { ... } `

### Resources:

* http://www.w3.org/TR/CSS21/selector.html#pattern-matching
* http://net.tutsplus.com/tutorials/html-css-techniques/the-30-css-selectors-you-must-memorize/
* http://estelle.github.io/selectors/


Content Layout
--------------

### Display Options

CSS provides a number of display options to control the flow of your document. These options can be used with the display style rule (`display: block`): 

* `inline`: elements are aligned inline with one another. Elements like `<span>` and `<a>` are inline by default.
* `inline-block`: elements flow inline, but may style rules like height and width can be applied. `<img>` elements default to inline-block.
* `block`: content will, by default, render on the next line after a block element. Elements like `<p>`, `<div>` and `<h1>` are block by default.
* `none`: content is hidden from the document and will not affect the flow of elements.

### Box Model

Every element in the DOM is a rectangular box. The center of the box is content, the size of which can be explicitly set width `height` and `width` style rules. Surronding that content, is `padding` -- the space between content and the `border`. The outer area of the box is the `margin` -- the negative space that separates and element from its neighbors.

A common misconception is that setting an object's width, either in pixels or percentage, will explicitly set the entire width of the box. By default, though, height and width only impact the sizing of and element's inner content. Set an element's width to 100% with a padding of 50px, and you might hate yourself later. Luckily, CSS3 is providing a nice solution to this problem.

### Box Sizing

If you want to make your life easier, you can use `{ box-sizing: border-box; }` to switch the box-sizing property to a more sensible box model default for every element on the page. This sets the width to **include** the border and the padding, allowing you to set the width to a percentage without having to do extremely hard calculations for borders and paddings.

Changing this property does have dramatic consequences, and might cause problems if you rely on pre-existing styles or frameworks like Bootstrap. Box sizing is also a CSS3 feature, so make sure to check [Can I Use](http://www.caniuse.com) and implement the necessary pre-fixes.

### Position Options

CSS provides 4 core position options to layout content on your page. For all of these options (except `static`), you can supply positive or negative values to rules like `top`, `left`, `right` and `bottom` to define the offset of the element's position:

* `static`: by default, all elements in the DOM are `{ position: static }`. It's very rare to explicitly define an element's position as static, unless you need to forcibly remove a previously added positioning rule, like in a responsive layout.
* `relative`: this option positions an element relative to its own default position. This can be useful to iron out any pesky vertical/horzontal alignment issues that may pop up. Setting a relative position also enforces the scope of any absolutely positioned descendent elements.
* `absolute`: absolutely positioned elements are removed from the document flow and placed absolutely in relation to the nearest parent with `relative` or `absolute` positioning. If no such parent exists, these elements are positioned relative to the `<html>` tag. Use but don't abuse -- too much absolute positioning can lead to a lot of colliding/overlapping madness.
* `fixed`: fixed positioning should be used sparingly for content that you always want to have visible. It's common to used `fixed` for headers or navigational elements on a page. Fixed elements are positioned relative to the viewport. Beware: fixed positioning can present many usability problems on small screens, or for users who have zoomed in too far in their viewport. Use with caution.

### Float and Clearfix

Floating and element is very common way to create a grid-based layout, implement a side bar, wrap text around and image, and so forth. By setting `{ float: right }` or `{ float: left }`, you are taking that element out of the normal document flow, and floating it either to the left or the right of it's siblings.

The one perk and drawback of the float is that the element's parent container no longer considers the floated child in it's height calculations. This is useful when trying to wrap paragraph text around an image, but less so when trying to put together a clean grid layout.

A popular hack to fix this is using what's referred to as a 'clearfix' to fix this clearing issue. First, add the name of your 'clearfix' class to the parent container (note: it doesn't need to be called 'clearfix' -- this is just convention). In CSS, we use the pseudo-element selecter `:after` to inject fake content to the end of the parent container, fixing the height calculation of the container to include the floated element:

    .clearfix:after {
       visibility: hidden;
       display: block;
       font-size: 0;
       content: " ";
       clear: both;
       height: 0;
    }

This style rule will place a hidden element with no height and a " " for content to extend the height of our parent element.

### Resources

* http://css-tricks.com/the-css-box-model/
* https://developer.mozilla.org/en-US/docs/CSS/box_model
* http://css-tricks.com/snippets/css/clear-fix/
* http://nicolasgallagher.com/micro-clearfix-hack/
* http://paulirish.com/2012/box-sizing-border-box-ftw/
* https://developer.mozilla.org/en-US/docs/CSS/box-sizing
* http://css-tricks.com/all-about-floats/
* http://coding.smashingmagazine.com/2007/05/01/css-float-theory-things-you-should-know/


Responsive Design
-----------------

### Media Queries

With the growing number of devices used to access web pages, developers need to make sure their experiences are user-friendly on any kind of device. One way to handle device differences is to use media queries to change content display based on pixel density, device width, and so forth. It's also great practice to set print media queries for printable web page content (hint: your resume) to make sure pages break before headers, after paragraphs, etc.

Media queries continue the cascading style rules, allowing the most specific and applicable rules to override default rules. Here are some common media query breakpoints courtesy of [CSS Tricks](http://css-tricks.com/snippets/css/media-queries-for-standard-devices/):

    /* Smartphones (portrait and landscape) ----------- */

    @media only screen and (min-device-width : 320px) and (max-device-width : 480px) {
      /* Styles */
    }

    /* Smartphones (landscape) ----------- */

    @media only screen and (min-width : 321px) {
      /* Styles */
    }

    /* Smartphones (portrait) ----------- */

    @media only screen and (max-width : 320px) {
      /* Styles */
    }

    /* iPads (portrait and landscape) ----------- */

    @media only screen and (min-device-width : 768px) and (max-device-width : 1024px) {
      /* Styles */
    }

    /* iPads (landscape) ----------- */

    @media only screen and (min-device-width : 768px) and (max-device-width : 1024px) and (orientation : landscape) {
      /* Styles */
    }

    /* iPads (portrait) ----------- */

    @media only screen and (min-device-width : 768px) and (max-device-width : 1024px) and (orientation : portrait) {
      /* Styles */
    }

    /* Desktops and laptops ----------- */

    @media only screen and (min-width : 1224px) {
      /* Styles */
    }

    /* Large screens ----------- */

    @media only screen and (min-width : 1824px) {
      /* Styles */
    }

    /* iPhone 4 ----------- */

    @media
    only screen and (-webkit-min-device-pixel-ratio : 1.5), only screen and (min-device-pixel-ratio : 1.5) {
      /* Styles */
    }

### Viewport Tag

Another helpful way to adapt your web experience for an array of devices is to include a meta viewport tag in your HTML `<head>`.

    <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1">

Including a tag like this helps you control the size of your content in the viewport, regardless of a device's default pixel density ratios, etc. There are a variety of options you can set for the content attribute to help you customize your app's experience. Read more [here](https://developer.mozilla.org/en-US/docs/Mobile/Viewport_meta_tag).

### Resources

* http://css-tricks.com/snippets/css/media-queries-for-standard-devices/
* http://mediaqueri.es/
* https://developer.mozilla.org/en-US/docs/Mobile/Viewport_meta_tag

Random Tips
-----------

1. Use CSS classes to toggle the state of an element. It's much more clean/efficient to add/remove a class to an element in JavaScript than to hard code new CSS rules for an element.

2. CSS3 has a lot of fun features like transitions and animations, but the spec is far from finalized. Make sure you always check [caniuse.com](http://www.caniuse.com) for browser compatibility, but also use vender prefixes (-webkit, -moz, -o, -ms) when using CSS3 features.

3. CSS frameworks like Bootstrap and Foundation use CSS resets to normalize user agent stylesheet differences. Have you ever tried to style a `<button>`? It's rough. To make your life easier, use a reset like [Normalize](http://necolas.github.io/normalize.css/) to ensure that your styles are consistent on all browsers.

4. It's hard to keep track of browser compatibility issues. If you really care about your IE-loving users, tools like [Modernizr](http://modernizr.com/) help you and your app feature detect and gracefully degrade modern features. Also check out [Initializr](http://www.initializr.com/) to generate boilerplate HTML5 templates to get your app going.

Helpful Resources
-----------------

* http://www.colorhexa.com
* http://css3generator.com/
* http://www.initializr.com
* http://www.w3.org/TR/CSS21/propidx.html
* https://developer.mozilla.org/en-US/docs/CSS/CSS_Reference
* http://caniuse.com/