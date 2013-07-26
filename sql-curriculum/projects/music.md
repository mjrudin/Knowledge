# Music Database App Assessment

## Description

**Duration**: 1.25hr

In this project, we will create a set of models and associations that
will represent a set of musicians, bands, and records.

* You will create a set of migrations and model classes to repesent
  the following concepts.
* You will create associations to connect the various models.
* You will not have to write any validations.

You are free to refer to your previous work and the internet while
working on this assessment.

## Models
### `Artist` and `Band`
* `Artist`
    * Should have a name.
* `Band`
    * Should have a name.

Write a pair of associations between `Artist` and `Band`. For
simplicity, assume that an `Artist` may only be a member of one
`Band`. Your association from `Artist` to `Band` should be named
`members`.

### `Song` and `Recording`
* `Song`
    * Should have a name.
    * Should have an associated `author`; assume a single `Artist`
      authors a song. `Artist` should have an `authored_songs`
      association.
* `Recording`
    * Repesents a recording of a `Song` by a `Band`. The same song can
      be recorded many `Band`s.
    * Should have a release date.
    * Should have a duration.
    * Should add associations named `song` and `band`.
    * Add an association from a `Song` to all its `recordings`.
    * Add an association from `Band`, through `Recording`, to
      `performed_songs`.
    * Add an association, `interpreters`, from `Song` to all of the
      `Band`s that have recorded it.

### Queries
* Write a class method which returns a hash where the keys are
  `Artist`s and the values are all the `Song`s they have
  authored. Avoid an N+1 query.
* Write a query that finds bands who have recorded the same song more
  than once. Avoid either an N+1 query or fetching all the
  songs/recordings/bands.
    * You may return `Band` objects, but you should be able to call
      `song_name` on the objects  and `recording_count`.
