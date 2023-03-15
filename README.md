Ushi (user history) - a training project, created to practice the use of such technologies as: ActiveJob, ActionCable, Sphinx, AJAX, JSON, Oauth2, ActionMailer, API, Authorization and Authentication.
The project carries functionality similar to StackOverflow. 
Any user can view the list of questions, view the question and the answers to the question. Can also see comments on the question and answers. Question and answers are rated.
The user can register in the application, having received great opportunities. Registration can take place both through the indication of a login / password, and through social networks.
A registered user can create a question, create an answer, comment, vote for the usefulness of another user's question or answer. Also, the author of the question can create a reward for the answer they like. The author of the question can choose the best answer. A system of asynchronous tasks has been implemented - sending letters to subscribers (tracking answers to a question), as well as a daily digest. The project has a full-text search function.
API has also been implemented.

The application was deployed to the server using capistrano
application servers were used passenger & unicorn with monit

The application was created according to the principle of TDD/BDD

Used technologies and gems:

* Ruby version - 2.7
* Rails 6.1
* devise
* bootstrap 5
* postgresql
* cancan
* for mail service use ActionMaler
* aws-sdk-s3
* sidekiq
* omniauth (omniauth-github omniauth-google-oauth2 omniauth-mailru-oauth2 omniauth-vkontakte)
* for js script use native js & jquery
* capistrano
* unicorn
* passenger
* capybara
* shoulda-matchers

