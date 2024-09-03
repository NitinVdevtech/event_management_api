# Project Name - Event Management API

The Event Management API is a Ruby on Rails application designed to provide a simple and efficient way to manage events. This API allows users to create, update, and view event details, as well as handle user authentication to secure access to these features.

## Table of Contents

- [Technology Stack](#technology-stack)
- [Setup](#setup)
- [API Endpoints](#api-endpoints)

## Technology Stack

### RUBY
  Installed ruby version
- **Ruby 3.0.0**: Programming language used in Rails development.
  ### with RVM
  - \curl -sSL https://get.rvm.io -o rvm.sh
  - rvm install ruby-x.x.x
  ### with rbenv
  - curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer | bash
  - rbenv install rbenv-x.x.x

### RAILS
  Installed rails version
- **Rails 7.1.3.4**: Backend framework for web development.


### Postgresql
  Installed postgresql version
- **Postgresql**: Database management system.

### Prerequisites
  Needed to run the appplication on the machine:
  - ruby-3.0.0
  - rails-7.1.3.4

  1. Clone the repository:
  - git clone https://github.com/NitinVdevtech/event_management_api

  2. `cd event_management_api`

  3. Run `bundle install`

  4. `create database.yml from example_database.yml and update the usename and password`

  5. Run `rails db:setup`

  6. Run `rails s`

## API Endpoints

 ### `POST \signup`
  #### Request URL -
    http://localhost:3000/api/v1/signup
  #### Request BODY - 
    {
      "user": {
        "name": "Johnq Doe",
        "email": "johndoe@example.com",
        "password": "password123",
        "admin": true
      }
    }
  #### Response -
    {
    "user": {
        "id": 2,
        "name": "Johnq Doe",
        "email": "johndoe@example.com",
        "password_digest": "$2a$12$GUc3cMWeOHz5EBfpmLkZTOdFw/SXSCwi2mbbWjhxdYnDC5ImsockS",
        "created_at": "2024-09-02T10:49:09.369Z",
        "updated_at": "2024-09-02T10:49:09.369Z",
        "admin": true
    },
    "token": "eyJhbGciOiJIUzI1NiJ9.eyJ1c2VyX2lkIjoyLCJleHAiOjE3MjUyNzc3NDl9.xcW-A3ELKJJ92JV4zaWogH8P8O8Z8tXiWehSlanyUns"
    }
 ### `POST \login`
   The `sign up` endpoint will return `token`, as shown in the sample response of the sign up.
   You have to set that token in the `headers` with the key `Authorization`.
  #### Request URL -
    http://localhost:3000/api/v1/login
  #### Request BODY - 
    {
      "user": {
        "email": "johndoe@example.com",
        "password": "password123"
      }
    }

## **NOTE**: The following Endpoint will run only after user have signed in.
 ### `GET \events`
  #### Request URL -
    http://localhost:3000/api/v1/events
  
  ### `POST \events`
  #### Request URL -
    http://localhost:3000/api/v1/events
  #### Request BODY - 
    {
      "user": {
        "name": "Johnq Doe",
        "email": "johndoe@example.com",
        "password": "password123",
        "admin": true
      }
    }

## **NOTE**: Get details of a specific event.
  ### `GET \events\:id`
  #### Request URL -
    http://localhost:3000/api/v1/events/:id
 
   ### `PUT \events\:id`
  #### Request URL -
    http://localhost:3000/api/v1/events/:id
  #### Request BODY - 
    {
      "user": {
        "name": "Johnq Doe"
      }
    }

   ### `DELETE \events\:id`
  #### Request URL -
    http://localhost:3000/api/v1/events/:id
