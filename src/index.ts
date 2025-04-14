import express, {Request, Response, NextFunction} from 'express';
import process from 'process';
import cors from "cors";
import * as dotenv from "dotenv";

dotenv.config();

const app = express();
const port = process.env.APP_PORT || 8080;

// Middleware
app.use(
    cors({
        origin: "*",
    })
);
app.disable('x-powered-by');
app.enable('trust proxy');
app.use(express.json());

// Routes
app.get('/', (req: Request, res: Response) => {
    res.setHeader('Cache-Control', 'no-store, no-cache, must-revalidate, proxy-revalidate');
    const appName = process.env.APP_NAME || "Node"
    res.status(200).json({
        message: `${appName}: Backend API is running!`
    });
});

app.post('/', (req: Request, res: Response) => {
    res.status(200).json({
        message: "Received POST request",
        data: req.body
    });
});

// 404 Handler
app.use((req: Request, res: Response, next: NextFunction) => {
    res.status(404).json({
        error: "Not Found",
        message: "The requested resource could not be found"
    });
});

// Error Handler (basic)
app.use((err: Error, req: Request, res: Response, next: NextFunction) => {
    console.error(err.stack);
    res.status(500).json({
        error: "Internal Server Error",
        message: "Something went wrong"
    });
});

// Server
const server = app.listen(port, () => {
    console.info(`Node app listening on port http://localhost:${port}`);
});

// Graceful shutdown
const gracefulShutdown = () => {
    console.log("Caught interrupt signal. Exiting...");
    process.exit(0);
};

process.on('SIGTERM', gracefulShutdown);
process.on('SIGINT', gracefulShutdown);
