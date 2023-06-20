import { Request, Response, NextFunction } from 'express';
import jwt from 'jsonwebtoken';


const SECRET = process.env.SECRET_KEY || "12345678";

export default function authenticateToken(req: Request, res: Response, next: NextFunction) {
    const authHeader = req.headers['authorization'];
    const token = authHeader && authHeader.split(' ')[1];

    if (token == null) return res.sendStatus(401);

    jwt.verify(token, SECRET, (err: any, user: any) => {
        if (err) return res.sendStatus(403);
        req.body.user = user;
        next();
    });
}
