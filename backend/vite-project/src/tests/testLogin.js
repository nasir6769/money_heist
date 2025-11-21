import { login } from '../auth.js'

async function run() {
  const result = await login("ksvarshini7@gmail.com", "12345678")
  console.log(result)
}

run()
