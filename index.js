import { create, globSource } from 'ipfs-http-client';

const client = create({ 
  host: 'localhost', 
  port: 5001,  
  protocol: 'http' 
});

const files = await client.addAll(
  globSource('./data', '**/*'), 
  { 
    wrapWithDirectory: true 
  }
);

for await (const file of files) {
  console.log(file);
}