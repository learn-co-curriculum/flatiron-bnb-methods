# Flatiron-BnB: Methods

Previously, we built out our model associations and set up our database. Now
we're going to work on building useful methods (class and instance) for
rendering data and our own validations. We're doing this to follow the fat
model, skinny controller principle. Additionally, we want to keep as little
logic in our views as possible.

## Instructions

There are many methods here. Check out the specs and **remember to run your
code in `rails c`** — that will help, I promise!

### City

  * The `#city_openings` method should return all of the `Listing` objects that
  are available for the **entire span** that is inputted.
  * The `.highest_ratio_res_to_listings` method should return the `City` that
  is "most full". What that means is it has the highest amount of reservations
  per listing.
  * The `.most_res` method should return the `City` with the most total number
  of reservations, no matter if they are all on one listing or otherwise.

### Listing

#### Validations

  * You'll need to write a few validations here, they are all pretty straight
  forward, just take a look at the tests!

#### Callbacks

  * Whenever a listing is created, the user attached to that listing should be
  converted into a "host". This means that the user's `host` field is set to
  `true`
  * Whenever a listing is destroyed (new callback! _Google it!_) the user
  attached to that listing should be converted back to a regular user. That
  means setting the `host` field to false.

### Neighborhood

The same class/instance methods as your `City` object. Maybe there is a way
they can share code?!?!?

### Reservation

#### Validations

  * Should have a `checkin` and a `checkout` method.
  * Make sure the guest and host aren't the same user.
  * Make sure any reservation that is made, doesn't conflict with others.
  * Make sure the checkout time is after the check in time.

**Note:** Remember, if you're having trouble setting up your models'
relationships, Google is your friend. There might be ways of designing
associations that you haven't encountered yet but that will vastly simplify
your code.

#### Methods

  * `#duration` gives the duration in days
  * `#total_price` returns the price using the duration and the price per day
  of the listing

### Review

#### Validations

  * Should have a description, rating and reservation
  * Reviews should only be created on reservations that exist and have already
  happened.

## Resources


* [Rails 4 Way: Validations](http://beta-library.herokuapp.com/books/the-rails-4-way#page=247)
* [Rails 4 Way: Callbacks](http://beta-library.herokuapp.com/books/the-rails-4-way#page=273)


<p data-visibility='hidden'>View <a href='https://learn.co/lessons/flatiron-bnb-methods'>Flatiron Bnb Methods Lab</a> on Learn.co and start learning to code for free.</p>
