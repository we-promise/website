# Sure Marketing Site

This is the marketing site for [Sure](https://sure.am), an OS for your personal finances.

## Local Development Setup

### Requirements

- Ruby >3 (see `Gemfile`)
- PostgreSQL >9.3 (ideally, latest stable version)

After cloning the repo, the basic setup commands are:

```sh
cd marketing
cp .env.example .env
bin/setup
bin/rails db:seed
bin/dev
```

Then, run `rails data:load_stocks` to seed the database with stock data.

### AI-assisted development

We fully support AI-assisted development. As a team, we typically use [Cursor](https://cursor.com) for that. As such, we've included files with some rules for Cursor and Claude Code, along with prompts for certain tasks.

## Copyright & license

Sure is distributed under an [AGPLv3 license](https://github.com/we-promise/sure/blob/main/LICENSE). "Sure" and the "S" logo are pending trademarks of Sure Finances, LLC
