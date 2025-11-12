"use client";

import apiHelper from "vinayak-api-helper";

export default function TestPage() {
  async function testApi() {
    try {
      
      // call GET API instead of POST
      const res = await apiHelper.organization.countryGet.getAllCountries();

      console.log("API Response:", res);
    } catch (error) {
    }
  }

  return (
    <div className="p-6">
      <button onClick={testApi} className="bg-blue-500 text-white p-2 rounded">
        Call GET Attendance
      </button>
    </div>
  );
}
