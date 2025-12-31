import {
  SQSClient,
  ReceiveMessageCommand,
  DeleteMessageCommand,
} from "@aws-sdk/client-sqs";

const REGION = process.env.AWS_REGION || "eu-central-1";
const QUEUE_URL = process.env.SQS_QUEUE_URL;

if (!QUEUE_URL) {
  console.error("Missing SQS_QUEUE_URL env var");
  process.exit(1);
}

const sqs = new SQSClient({ region: REGION });

async function handleMessage(msg) {
  console.log("Got message:", msg.MessageId);

  let payload;
  try {
    payload = JSON.parse(msg.Body);
  } catch (e) {
    console.error("Invalid JSON:", msg.Body);
    throw e;
  }

  if (payload.type === "ping") {
    console.log(`[PING] ${payload.message} @ ${payload.sentAt}`);
    return;
  }

  throw new Error(`Unknown message type: ${payload.type}`);
}

async function poll() {
  while (true) {
    try {
      const res = await sqs.send(
        new ReceiveMessageCommand({
          QueueUrl: QUEUE_URL,
          MaxNumberOfMessages: 10,
          WaitTimeSeconds: 20,
          VisibilityTimeout: 60,
        })
      );

      const messages = res.Messages ?? [];
      for (const msg of messages) {
        try {
          await handleMessage(msg);

          await sqs.send(
            new DeleteMessageCommand({
              QueueUrl: QUEUE_URL,
              ReceiptHandle: msg.ReceiptHandle,
            })
          );

          console.log(`Message ${msg.MessageId} processed and acknowledged`);
        } catch (e) {
          console.error("Message processing failed:", msg.MessageId, e);
        }
      }
    } catch (e) {
      console.error("Polling error:", e);
      await new Promise((r) => setTimeout(r, 2000));
    }
  }
}

// poll().catch((err) => {
//   console.error("Fatal:", err);
//   process.exit(1);
// });
