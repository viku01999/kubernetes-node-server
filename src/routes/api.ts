import { Router, Request, Response } from "express";


const router: Router = Router();

router.get("/hello", (req: Request, res: Response) => {
  const podName = process.env.HOSTNAME || "unknown-pod";

  res.json({
    message: "Hello from Node + TypeScript API running in Kubernetes!",
    pod: podName
  });
});


export default router;
