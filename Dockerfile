FROM python:2.7-alpine
COPY ./my_bot.py /bot.py
CMD python /bot.py