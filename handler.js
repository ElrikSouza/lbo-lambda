const util = require("util");
const exec = util.promisify(require("child_process").exec);
const { readFile } = require("fs/promises");

module.exports.handler = async (event, context) => {
  console.log("event:", event);
  console.log("context:", context);
  const { stdout } = await exec(
    "libreoffice7.6 --headless --convert-to pdf /var/task/test.docx --outdir /tmp ",
  );
  console.log("-----");
  console.log(stdout);
  console.log("-----");

  const file = await readFile("/tmp/test.pdf");

  const response = {
    statusCode: 200,
    headers: {
      "Access-Control-Allow-Origin": "*",
      "Access-Control-Allow-Methods": "GET, POST",
      "Content-type":
        "application/vnd.openxmlformats-officedocument.wordprocessingml.document",
      "Content-Disposition": 'inline; filename="rename.docx"',
    },
    body: file.toString("base64"),
  };
  return response;
};
