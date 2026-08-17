// prisma/seed.ts
import { PrismaClient } from '@prisma/client'
import bcrypt from 'bcrypt'

const prisma = new PrismaClient()

async function main() {
  const hashed = await bcrypt.hash('admin', 10)

  await prisma.admin.upsert({
    where: { username: 'superadmin' },
    update: {},
    create: {
      username: 'superadmin',
      hashed_password: hashed,
      is_super: true,
    },
  })

  console.log('Admin user seeded.')
}

main().finally(() => prisma.$disconnect())
