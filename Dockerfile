FROM python:3.12-slim

WORKDIR /srv/token-shop
RUN python -m pip install --no-cache-dir flask gunicorn

COPY app.py ledger.py index.html flag.txt ./
COPY static ./static

RUN useradd --system --create-home token-shop && chown -R token-shop:token-shop /srv/token-shop
USER token-shop

ENV PORT=8080
EXPOSE 8080

CMD ["gunicorn", "--bind", "0.0.0.0:8080", "--workers", "1", "--threads", "1", "--timeout", "20", "--graceful-timeout", "5", "--limit-request-line", "2048", "--limit-request-fields", "20", "--limit-request-field_size", "2048", "--log-level", "warning", "app:app"]