# Swapi

[![CircleCI](https://dl.circleci.com/status-badge/img/gh/jhonisds/swapi/tree/main.svg?style=svg)](https://dl.circleci.com/status-badge/redirect/gh/jhonisds/swapi/tree/main)


## Objective
We need to develop a REST API that contains the data of the planets in the Star Wars franchise.

## Scope

For each planet, the following data must be obtained from the application database, entered from requests fired to the Star Wars public API:
- Name, climate and terrain;
- For each planet we should also have the movies with the name, director and release date;

The necessary information can be obtained from the [public Star Wars API](https://swapi.dev/)

## Features

- Load a planet from the API through the Id List the planets
- Search for planet by name
- Search by ID
- Remove planet


## Requirements

- Use git or hg for version control of the test solution and host it on Github or Bitbucket
- Store the data in the database you deem appropriate
- API must follow REST concepts
- the Content-Type of the API responses must be application/json
- The solution code must contain tests and some documented mechanism to generate the test coverage
- Test coverage
- The application must record structured logs in a text file
- The solution in this evaluation must be documented in Portuguese or English. Choose a language in which you are fluent
- the test solution documentation must include how to run the project and examples of requests and their possible answers

## Run service

run:

```sh
make docker.app.start
```

## Run application

Execute this command to start the application:

```sh
mix start
```

## API Documentation

[Endpoint documentation](https://swapidomain.docs.apiary.io/#)

## References

- [Learn Functional Programming With Elixir](https://pragprog.com/titles/cdc-elixir/learn-functional-programming-with-elixir/)
- [Elixir in Action](https://www.manning.com/books/elixir-in-action-second-edition)
- [Programming Elixir 1.6](https://pragprog.com/titles/elixir16/programming-elixir-1-6/)
