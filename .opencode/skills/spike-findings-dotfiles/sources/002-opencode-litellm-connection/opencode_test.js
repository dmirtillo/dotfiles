import { generateText } from 'ai';
import { createOpenAI } from '@ai-sdk/openai';

const openai = createOpenAI({
  baseURL: 'http://localhost:4001/v1',
  apiKey: 'sk-1234',
});

async function main() {
  console.log("Testing ai-sdk against LiteLLM Proxy...");
  try {
    const { text, toolCalls } = await generateText({
      model: openai('gemini-3.1-flash-lite-preview'),
      prompt: 'What is the cost of Cloud Run in us-central1? Please use the `get_estimation_guide` tool.',
      // Let's pass the tools in standard format and see what happens, 
      // but LiteLLM expects the specific mcp type in the tools array. 
      // This is the crux of the issue: AI SDK does not know about MCP tools on the proxy.
    });
    console.log(text);
    console.log(toolCalls);
  } catch (error) {
    console.error(error);
  }
}

main();
