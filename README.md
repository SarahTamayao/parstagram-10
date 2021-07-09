# Project 4 - *Parstagram*

**Parstagram** is a photo sharing app using Parse as its backend.

Time spent: **20** hours spent in total

## User Stories

The following **required** functionality is completed:

- [x] User can sign up to create a new account using Parse authentication
- [x] User can log in and log out of his or her account
- [x] The current signed in user is persisted across app restarts
- [x] User can take a photo, add a caption, and post it to "Instagram"
- [x] User can view the last 20 posts submitted to "Instagram"
- [x] User can pull to refresh the last 20 posts submitted to "Instagram"
- [x] User can tap a post to view post details, including timestamp and caption. This page doesn't really show more details than the feed, but it does display a more detailed timestamp.

The following **optional** features are implemented:

- [x] Run your app on your phone and use the camera to take the photo
- [ ] User can load more posts once he or she reaches the bottom of the feed using infinite scrolling.
- [x] Show the username and creation time for each post
- [x] User can use a Tab Bar to switch between a Home Feed tab (all posts) and a Profile tab (only posts published by the current user)
- User Profiles:
  - [x] Allow the logged in user to add a profile photo
  - [x] Display the profile photo with each post
  - [ ] Tapping on a post's username or profile photo goes to that user's profile page
- [x] After the user submits a new post, show a progress HUD while the post is being uploaded to Parse
- [ ] User can comment on a post and see all comments for each post in the post details screen.
- [x] User can like a post and see number of likes for each post in the post details screen. (This feature isn't reflected in the gifs because I got it to work after making the gifs.)
- [x] Style the login page to look like the real Instagram login page.
- [x] Style the feed to look like the real Instagram feed.
- [ ] Implement a custom camera view.

The following **additional** features are implemented:

- [x] A center progress HUD shows only the *first* time the feed is loaded, and not when pulling to refresh afterward.
- [x] It takes a long time for the image picker to load on the Xcode simulator, so I've added a progress HUD when the user wants to change their profile picture.
- [x] Alerts: 
    - [x] On login screen, when either username or password field is blank
    - [x] Confirmations when exiting the Compose Post view, and when logging out
    - [x] When attempting to post without selecting an image, and when caption is too long (>2200 characters)

Please list two areas of the assignment you'd like to **discuss further with your peers** during the next class (examples include better ways to implement something, how to extend your app in certain ways, etc):

1. How to create a profile page that isn't part of the Profile tab (so you can tap on a post's profile photo to view the poster's profile) without creating a new view controller
2. How to add support for being logged into multiple accounts at the same time

## Video Walkthrough

Here's a walkthrough of implemented user stories. The gifs showcase, in order:
1. Sign up for new account, log in and log out, user persistence across app restarts
2. View posts in feed (showing username, creation time, and profile photo), create new post, progress HUDs and alerts, pull to refresh, details view, and using the camera on a real phone (post shows up in feed).
3. User profile, collection view of posts by the current user, ability to change profile picture

![ig_login](https://user-images.githubusercontent.com/43052066/125131093-2d22b200-e0d0-11eb-8a62-965fc9c8742e.gif)
![ig_post](https://user-images.githubusercontent.com/43052066/125131104-30b63900-e0d0-11eb-987d-54b94b2e42a3.gif)

![ig_profile](https://user-images.githubusercontent.com/43052066/125131109-33189300-e0d0-11eb-9abe-ad2971ffa707.gif)


## Credits

List an 3rd party libraries, icons, graphics, or other assets you used in your app.

- [AFNetworking](https://github.com/AFNetworking/AFNetworking) - networking task library
- [Parse](https://parseplatform.org/) - "effortless backend"
- [DateTools](https://github.com/MatthewYork/DateTools) - short "time ago" strings
- [MBProgressHUD](https://github.com/matej/MBProgressHUD) - progress indicators


## Notes

Describe any challenges encountered while building the app.
- Setting up the header in the Profile tab (had to make it a CollectionViewCell reusable component)
- Flow layout of the collection view (large image appearing first; correct grid layout would only show up when user scrolls). This was fixed when a TA suggested to set the collection view's Estimate Size property to None.
- When implementing the liking/unliking feature, it seemed that adding a user id to the post's likedBy array wouldn't be reflected in the Parse database. A TA helped me solve this by adding self.post[@"likedBy"] = self.post.likedBy before saving the object to Parse.

## License

    Copyright 2021 Emily Jiang

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
