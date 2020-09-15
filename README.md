[![Build Status](https://travis-ci.com/marciofrayze/meeting-price-counter-elm.svg?branch=master)](https://travis-ci.com/marciofrayze/meeting-price-counter-elm)

# Meeting Price Counter

**This is a work in progress.**

Preliminary version (no css/layout yet) available at: [https://meeting-price-counter.web.app/](https://meeting-price-counter.web.app/)

## What is this?

As the name implies, this will be a simple web app where you can count how much money is being spent on a meeting.
Just enter the number of attendees, the average salary and click start counting.

## Why?

This project was created so I could learn more about the [elm programming language](https://elm-lang.org/) and [TDD](https://martinfowler.com/bliki/TestDrivenDevelopment.html).

## Minimum requirements
```
 npm install -g elm elm-test
```

## Recommended dependencies
```
 npm install -g elm elm-test elm-oracle elm-format
```

## How to run the tests
```
git clone git@github.com:mfdavid/meeting-price-counter-elm.git
cd meeting-price-counter-elm
elm-test
```

## Test coverage report
```
npm i -g elm-coverage
elm-coverage --open
```

## How to run localy
```
elm reactor

Then go to http://localhost:8000/src/Main.elm
```
