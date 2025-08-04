Hi! :)

### instructions
1. This project assumes an rvm installation with ruby 3.3.5 installed. The ruby version is dictated by the .ruby-version file in the repository.

2. Clone the repository via standard github instructions, cd into the repo & run `bundle install` to bring all required gems onto your system.

3. Create the database & run migrations using standard rails commands: `rails db:create`, `rails:db:migrate`
(See config/database.yml for more information & please internet search any errors you encounter - db setup outside the scope of this readme)

4. run tests from the root of the repo: `rspec`

### developer notes for this take home

1. For the most, part, you can look at the commit history & long commit message to see any commands used to initialize the rails project.
2. As I got going, my commit history got a little sloppy. This is something I would clean up were it production code.
3. Test cover is "ok-ish". I tried to cover most happy paths at the controller level.
4. This is not linted up to my standards - if I had more time I would clean up the code & perform some extractions/refactors (after beefing up the specs).
5. Without more requirements on how the system will be used, I went with a quick mysql setup for this prototype. If this were intended for production, I would want to discuss more options with my team. The game_events table in particular might work better as a json store, for example.
6. Where possible, I tried to use out-of-box rails 8 solutions, for example, I used the rails authentication generator for auth, then modified it to be token based instead of cookie based. This blog post came in handy & I used a lot of the author's techniques: https://a-chacon.com/en/on%20rails/2024/10/16/poc-using-rails-8-auth-system-in-api-only.html
7. "Note: the service recalculates the subscription status of users every 24h." - I quickly coded up something in the users#stats to only request the subscription status if the existing field in the user's record was older than one day, but have not had time to test it, so it probably has bugs. But it was my intention to reduce those calls when possible.
8. As of right now, the github ci workflow is running into trouble. My experience with running CI is with AWS Code Build & I am still tinkering to get it right for this project.

:)
