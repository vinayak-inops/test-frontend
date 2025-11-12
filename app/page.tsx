"use client";
import TestPage from "./_components/AttendanceManager";

export default function Home() {
 
  return <div>
    <p>{process.env.NEXT_PUBLIC_APP_NAME} this env value test</p>
    <p>{process.env.NEXT_PUBLIC_ENV} this env value test</p>
    <TestPage />
  </div>;
}
