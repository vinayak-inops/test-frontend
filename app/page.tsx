"use client";
import TestPage from "./_components/AttendanceManager";

export default function Home() {
 
  return <div>

    {process.env.NEXT_PUBLIC_ENV} {process.env.NEXT_PUBLIC_APP_NAME}
    <TestPage />
  </div>;
}
