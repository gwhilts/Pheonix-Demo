# Chirp

Following along with Chris McCord's Phoenix demo video [Build a real-time Twitter clone in 15 minutes with LiveView and Phoenix 1.5](https://www.youtube.com/watch?v=MZvmYaFkNJI&t=359s)

Some differences will be present because I'm using Phoenix 1.7 instead of 1.5, and also because I might experiment and play around.

All material should be considered (c) Chris McCord, licensed under the [MIT License](https://github.com/phoenixframework/phoenix/blob/master/LICENSE.md) unless otherwise specified.


## Congiguration

Because I'm hesitant to store my PostgreSQL credentials in public, even dev and test, I've omitted `config/dev.exs` and `config/test.exs` from git commits. If you use use this code (seriously, why would you?!), you'll need to rename `config/dev.exs_template` and `config/test.exs_template`, then add your own db credentials.
