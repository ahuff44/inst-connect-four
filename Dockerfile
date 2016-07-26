FROM ruby:2.3-alpine
COPY ./my_bot.rb /bot.rb
COPY ./brain.rb /brain.rb
CMD ruby /bot.rb