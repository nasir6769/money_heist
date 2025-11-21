import { signUp } from '../auth.js'

async function run() {
  const result = await signUp("ksvarshini7@gmail.com", "12345678")
  console.log(result)
}

run()
