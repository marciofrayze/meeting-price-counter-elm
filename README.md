[![Build Status](https://travis-ci.com/marciofrayze/meeting-price-counter-elm.svg?branch=master)](https://travis-ci.com/marciofrayze/meeting-price-counter-elm)

# Meeting Price Counter

Available at: [https://meeting-price-counter.web.app/](https://meeting-price-counter.web.app/)

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
npm install -g elm elm-test elm-oracle elm-format elm-json @elm-tooling/elm-language-server elm-review
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

## How to upgrade all dependencies
```
elm-json upgrade
```

If you want to update major versions (unsafe upgrade):
```
elm-json upgrade --unsafe
```

## Elm-review
This project uses [elm-review](https://github.com/jfmengels/elm-review) to help find mistakes.
```
elm-review
```
The rules are configured in the `review` folder.
