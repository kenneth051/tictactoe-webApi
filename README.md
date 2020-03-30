# WebApi
Welcome to tictatctoe web API, you can play the game with a colleague on postman or consume it on a frontend.

## Getting Started
These instructions will enable you to run the project

**Prerequisites**
Below are the things you need to get the project up and running.
git : To update and clone the repository
ruby: Language used to develop the api


**Clone the repository to your computer**
run `git clone https://github.com/kenneth051/tictactoe-webApi.git` to clone the project.

- In the project's root directory,Install the dependencies needed using bundler by running `bundler install` in the terminal.

**Tests and Deevelopement**
After checking out the repo and installing dependencies. Run `rackup` in the terminal to start the sinatra server. Run `rake spec` or  `rspec` to run the tests. 

**ENDPOINTS**

		METHOD             ACTIVITY                     ENDPOINT
		-POST             playing the game              /play
		
		-GET             getting the board              /draw

		-GET             reset game                     /reset_game

## Usage of the endpoints.
**/play**
data to be passed should be in json format for example.

            {
                "symbol":"o",
                "position":9
            }

symbol can either be `'x'` or `'o'`

position should be in the range of `1-9`.
