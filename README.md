# Project 1 - Flix

Flix is a movies app using the [The Movie Database API](http://docs.themoviedb.apiary.io/#).

Time spent: 9 hours spent in total

## User Stories

The following **required** user stories are complete:

- [x] User sees app icon in home screen and styled launch screen (+1pt)
- [x] User can scroll through a list of movies currently playing in theaters from The Movie DB API (+5pt)
- [x] User can "Pull to refresh" the movie list (+2pt)
- [x] User sees a loading state while waiting for the movies to load (+2pt)

The following **stretch** user stories are implemented:

- [x] User sees an alert when there's a networking error (+1pt)
- [x] User can search for a movie (+3pt)
- [x] While poster is being fetched, user see's a placeholder image (+1pt)
- [x] User sees image transition for images coming from network, not when it is loaded from cache (+1pt)
- [x] Customize the selection effect of the cell (+1pt)
- [x] For the large poster, load the low resolution image first and then switch to the high resolution image when complete (+2pt)

The following **additional** user stories are implemented:

- [x] The scroll bar still is shown when scrolling through the list of movies

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. For the movies instance variable I decided to use an array of tuples containing the movie title, overview, and poster path [(title: String, overview: String, posterPath: String)], instead of using an array of dictionary [[String: Any]] because these are the only values from the response that are used in this application. This allows me to only do casting when fetching data, and not do casting whenever I need the movies variable.
2. Swift provides helpful array methods for traversing an array, such as filter and map. Array.filter() returns a new array of the elements that satisfy a certain condition. Array.map() returns an array containing the results of the mapping.

## Video Walkthrough

Here's a walkthrough of implemented user stories:

![](https://github.com/Li-Victor/Flix/blob/master/1.gif)

![](https://github.com/Li-Victor/Flix/blob/master/2.gif)

![](https://github.com/Li-Victor/Flix/blob/master/3.gif)

GIF created with [Giphy Capture](https://giphy.com/apps/giphycapture).

## Notes

Loading a low resolution image first and then switching to a higher resolution image when complete was difficult task, as I didn't understand the guides. Then, I researched and found that AlamoFire setImage function has a completion closure, that runs after the image has been set. After the low resolution image was completed, the higher resolution image is set on the same cell.

Renaming a XCode project takes a ton of steps. Have a good name for a project, so you would not have to rename it.

## License

    Copyright 2018 Victor Li

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
