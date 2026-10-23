import assert from 'node:assert/strict'
import test from 'node:test'
import { assertDemoProject, DEMO_PROJECT_URL } from '../lib/demo.ts'

test('demo refuses production and lookalike database URLs', () => {
  assert.doesNotThrow(() => assertDemoProject(DEMO_PROJECT_URL))
  for (const url of ['', 'https://emhbjgeptswvxxklftwh.supabase.co', `${DEMO_PROJECT_URL}.evil.example`, 'http://ovbvnqhoexmdjqrstquz.supabase.co']) {
    assert.throws(() => assertDemoProject(url))
  }
})
