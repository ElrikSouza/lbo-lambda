### BUILD & RUN:

docker build --platform linux/amd64 -t lbo:test . && docker run --platform linux/amd64 -p 9000:8080 lbo:test

### CALL THE LAMBDA:

curl "http://localhost:9000/2015-03-31/functions/function/invocations" -d '{}'

### DOWNLOAD THE RESULT FILE

if you don't have jq, just pipe the body string to base64 -d

curl "http://localhost:9000/2015-03-31/functions/function/invocations" -d '{}' | jq -r '.body' | base64 -d >> result2.pdf
