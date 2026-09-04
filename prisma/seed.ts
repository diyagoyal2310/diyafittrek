import { PrismaClient } from "@prisma/client";
import bcrypt from "bcryptjs";
import { calculateRecoveryScore } from "../src/lib/algorithms/recoveryCalculator";

const db = new PrismaClient();

const DEMO_EMAIL = "demo@fitpulse.ai";
const DEMO_PASSWORD = "password123";

async function main() {
  const passwordHash = await bcrypt.hash(DEMO_PASSWORD, 10);

  const user = await db.user.upsert({
    where: { email: DEMO_EMAIL },
    update: {},
    create: {
      email: DEMO_EMAIL,
      name: "Demo Lifter",
      passwordHash,
      goal: "RECOMP",
      weightKg: 82,
      heightCm: 178,
      age: 29,
      sex: "MALE",
      bodyFatPct: 15,
    },
  });

  const today = new Date();
  for (let i = 13; i >= 0; i--) {
    const date = new Date(today);
    date.setDate(date.getDate() - i);

    const sleepScore = 60 + Math.round(Math.random() * 30);
    const hrv = 40 + Math.round(Math.random() * 25);
    const activeCalories = 300 + Math.round(Math.random() * 400);
    const recoveryScore = calculateRecoveryScore({
      sleepScore,
      hrv,
      baselineHrv: 55,
      activeCalories,
    });

    await db.biometricLog.create({
      data: {
        userId: user.id,
        date,
        activeCalories,
        restingHeartRate: 55 + Math.round(Math.random() * 10),
        sleepScore,
        hrv,
        recoveryScore,
      },
    });
  }

  const latestBiometric = await db.biometricLog.findFirst({
    where: { userId: user.id },
    orderBy: { date: "desc" },
  });

  const session = await db.workoutSession.create({
    data: {
      userId: user.id,
      name: "Push Day",
      goal: user.goal,
      readinessAtStart: latestBiometric?.recoveryScore ?? 75,
      completedAt: new Date(),
      createdAt: new Date(Date.now() - 2 * 24 * 60 * 60 * 1000),
    },
  });

  const exercises = [
    { exerciseName: "Barbell Bench Press", weightKg: 80, reps: 8, rpe: 8 },
    { exerciseName: "Barbell Bench Press", weightKg: 80, reps: 7, rpe: 8.5 },
    { exerciseName: "Overhead Press", weightKg: 45, reps: 8, rpe: 8 },
    { exerciseName: "Incline Dumbbell Press", weightKg: 30, reps: 10, rpe: 7.5 },
  ];
  for (const set of exercises) {
    await db.workoutSet.create({
      data: { workoutSessionId: session.id, ...set },
    });
  }

  for (let i = 2; i >= 0; i--) {
    const date = new Date(today);
    date.setDate(date.getDate() - i);
    await db.nutritionLog.create({
      data: {
        userId: user.id,
        date,
        mealName: "Lunch",
        calories: 650,
        proteinG: 55,
        carbsG: 60,
        fatG: 18,
      },
    });
  }

  console.log(`Seeded demo user: ${DEMO_EMAIL} / ${DEMO_PASSWORD}`);
}

main()
  .catch((err) => {
    console.error(err);
    process.exitCode = 1;
  })
  .finally(async () => {
    await db.$disconnect();
  });
