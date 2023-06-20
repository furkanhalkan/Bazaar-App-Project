import { PrismaClient } from "@prisma/client";
import { Router } from "express";
import bcrypt from 'bcrypt';
import jwt from 'jsonwebtoken';
import authenticateToken from '../middleware/auth';

const prisma = new PrismaClient()

export const auth = Router();

const SECRET = process.env.SECRET_KEY || "12345678";

// Kayıt işlemi
auth.post('/register', async (req, res) => {
    const { user_id, mail, password, phone, name_surname } = req.body;

  try 
  {
    
    // E-postanın var olup olmadığını kontrol et
    const emailExists = await prisma.users.findUnique({ where: { mail:mail } });

    if (emailExists) {
      return res.status(400).json({ error: "Email already exists" });
    }


    // Kullanıcının parolasını hash'le
    const hashedPassword = await bcrypt.hash(password, 10);

    // Yeni kullanıcıyı veritabanına ekle
    const user = await prisma.users.create({
      data: {
        user_id,
        mail,
        password: hashedPassword,
        phone,
        name_surname,
        mail_verification: false,
        phone_verification: false
      }
    });

    // Kullanıcıya geri dönüş yap
    return res.status(201).json(user);
    
  } 
  catch (err) 
  {
    console.log(err);
    return res.status(500).json({ error: "Something went wrong" });
  }
});

// Login işlemi
auth.post('/login', async (req, res) => {
    const { mail, password } = req.body;

    const user = await prisma.users.findUnique({ where: { mail: mail } });

    if (!user) return res.status(400).json({ message: 'User not found' });

    const isMatch = await bcrypt.compare(password, user.password);
    if (!isMatch) return res.status(400).json({ message: 'Invalid password' });

    const token = jwt.sign({ id: user.id, username: user.mail }, SECRET, { expiresIn: '4h' });

    res.json({ token });
});

// Yetkilendirme
auth.get('/secret', authenticateToken, async (req, res) => {
    res.json({ message: 'Secret message' });
});