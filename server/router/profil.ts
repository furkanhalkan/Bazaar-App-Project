import { PrismaClient } from "@prisma/client";
import { Router } from "express";
import authenticateToken from '../middleware/auth';

const prisma = new PrismaClient()

export const profil = Router();

profil.get('/profile/:user_id', authenticateToken, async (req, res) =>{
    const userId = req.params.user_id;

    try 
    {
        // Kullanıcının bilgilerini veritabanından alıyoruz.
        const user = await prisma.users.findUnique({
        where: {
            user_id: userId
        }
        });

        if (!user) {
        return res.status(400).json({ error: "User not found" });
        }

        // Parola gibi hassas bilgilerin dönüşte yer almaması için password alanını sileriz.
        const safeUser = {
        id: user.id,
        user_id: user.user_id,
        mail: user.mail,
        phone: user.phone,
        name_surname: user.name_surname,
        mail_verification: user.mail_verification,
        phone_verification: user.phone_verification,
        createdAt: user.createdAt,
        updatedAt: user.updatedAt
        };

        return res.status(200).json(safeUser);
    } 
    catch (err) 
    {
        console.log(err);
        return res.status(500).json({ error: "Something went wrong" });
    }
});
