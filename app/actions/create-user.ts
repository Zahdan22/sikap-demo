'use server'

const message = 'Pengelolaan akun dinonaktifkan pada versi demo.'
export async function createCrewAccount(_username: string, _password: string, _nama: string) {
  return { success: false, message }
}
export async function deleteCrewAccount(_userId: string) {
  return { success: false, message }
}
export async function setCrewActive(_userId: string, _active: boolean) {
  return { success: false, message }
}
