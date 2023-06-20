import { PrismaClient } from "@prisma/client";
import { Router } from "express";
import authenticateToken from '../middleware/auth';

const prisma = new PrismaClient()

export const pazar = Router();

pazar.post('/register', authenticateToken, async (req, res) => {
    const { pazar_id,pazar_adi,pazar_turu,adres,il,ilce,Gunler,Description } = req.body;
    //res.send(result);
    try
    {
        const pazarExists = await prisma.pazars.findUnique({ where: { pazar_id:pazar_id } });

        if (pazarExists) {
        return res.status(400).json({ error: "Pazar already exists" });
        }

        const user = await prisma.pazars.create({
            data: {
              pazar_id,
              pazar_adi,
              pazar_turu,
              adres,
              il,
              ilce,
              Gunler,
              Description
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

pazar.get('/pazars', async (req, res) => {
    try {
        const pazars = await prisma.pazars.findMany({
            orderBy: {
                createdAt: 'desc'
            }
        });

        return res.status(200).json(pazars);

    } catch (err) {
        console.log(err);
        return res.status(500).json({ error: "Something went wrong" });
    }
});