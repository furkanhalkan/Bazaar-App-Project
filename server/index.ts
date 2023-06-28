import { Prisma, PrismaClient } from '@prisma/client';
import express from 'express';
import helmet from 'helmet';
import morgan from  'morgan';
import multer from 'multer';
import cors from 'cors';
import bodyParser from 'body-parser';

const prisma = new PrismaClient()
const app = express();
const router = express.Router();

import {auth} from './router/auth';
import {pazar} from './router/pazar';
import {profil} from './router/profil';

app.use(cors());
app.use(express.json());
app.use(helmet());
app.use(morgan("common"));

app.use(bodyParser.urlencoded({ extended: true }));

app.use(bodyParser.json());


const storage = multer.diskStorage({
    destination: (req, file, cb) => {
      cb(null, "public/images");
    },
    filename: (req, file, cb) => {
      cb(null, req.body.name);
    },
  });

  const upload = multer({ storage: storage });
  app.post("/api/upload", upload.single("file"), (req, res) => {
    try {
      return res.status(200).json("File uploded successfully");
    } catch (error) {
      console.error(error);
    }
  });

app.get('/', async (req, res) => {
    res.sendStatus(200);
});

app.use("/api/auth",auth);
app.use("/api/pazar",pazar);
app.use("/api/profil",profil);

const server = app.listen(3000, () =>
  console.log(`🚀 Server ready at: http://localhost:3000`),
);