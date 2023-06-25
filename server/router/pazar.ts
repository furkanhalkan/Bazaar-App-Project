import { Prisma, PrismaClient } from "@prisma/client";
import { Router } from "express";
import authenticateToken from '../middleware/auth';
import axios from 'axios';

const prisma = new PrismaClient()

export const pazar = Router();

pazar.post('/register', authenticateToken, async (req, res) => {
    const { pazar_id,pazar_adi,pazar_turu,adres,il,ilce,Gunler,Description } = req.body;

    try
    {
        const pazarExists = await prisma.pazars.findUnique({ where: { pazar_id:pazar_id } });

        if (pazarExists) {
            return res.status(400).json({ error: "Pazar already exists" });
        }


        // Adres bilgisini kullanarak enlem ve boylamı elde edin
        const location = await getLatLng(`${adres}, ${il}, ${ilce}`);

        const user = await prisma.pazars.create({
            data: {
              pazar_id,
              pazar_adi,
              pazar_turu,
              adres,
              il,
              ilce,
              Gunler,
              Description,
              latitude: location?.latitude || null,  // Veritabanına latitude bilgisini kaydet
              longitude: location?.longitude || null // Veritabanına longitude bilgisini kaydet
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


pazar.get('/detay/:id', async (req, res)=> {
    try{
        const pazar = await prisma.pazars.findUnique({
            where: {
                pazar_id:req.params.id
            },
        });

        if(!pazar)
        {
            throw new Error('Belitilen pazar bulunamadi');
        }

        const pazarDetails = {
            id:pazar.id,
            pazar_id:pazar.pazar_id,
            pazar_adi:pazar.pazar_adi,
            pazar_turu:pazar.pazar_turu,
            adres:pazar.adres,
            il:pazar.il,
            ilce:pazar.ilce,
            gunler:pazar.Gunler,
            description:pazar.Description,
            createdAt:pazar.createdAt,
            updatedAt:pazar.updatedAt,
        };

        return res.status(201).json(pazarDetails);
    }
    catch(err){
        console.log('Error: ',err);
        res.status(404).json({error:'Belirtilen Pazar Bulunamadi'});
    }
});

pazar.post('/arama', async (req, res) => {
    const {il, ilce, gunler} = req.body;

    const where: Prisma.pazarsWhereInput={};

    if(il){
        where.il=il;
    }

    if(ilce){
        where.ilce;
    }

    if(gunler){
        where.Gunler=gunler;
    }

    try {
        const pazars=await prisma.pazars.findMany({where});
        res.status(201).json(pazars);
    }
    catch(err)
    {
        console.log('Error: ',err);
        res.status(500).json({error:'An error occurred while retrieving pazars'});
    }
});

async function getLatLng(address: string): Promise<{latitude: string, longitude: string} | null> {
    try {
      const response = await axios.get(
        `https://maps.googleapis.com/maps/api/geocode/json`, {
          params: {
            address: address,
            key: process.env.GOOGLE_API, // Google Cloud Console'dan aldığınız API anahtarınız
          },
        }
      );
  
      if (response.data.results[0]) 
      {
        const location = response.data.results[0].geometry.location;
        return {latitude: location.lat.toString(), longitude: location.lng.toString()};
      } 
      else 
      {
        return null;
      }
    } 
    catch (error) 
    {
      console.log(`Failed to get coordinates for address "${address}":`, error);

      return null;
    }
  }


