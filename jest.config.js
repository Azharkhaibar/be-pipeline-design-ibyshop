/** @type {import('ts-jest').JestConfigWithTsJest} */
module.exports = {
  preset: 'ts-jest', // Menggunakan ts-jest untuk kompilasi TypeScript
  testEnvironment: 'node', // Lingkungan pengujian menggunakan Node.js
  transform: {
    '^.+\\.tsx?$': 'ts-jest', // Untuk mengonversi file .ts dan .tsx menggunakan ts-jest
  },
  moduleFileExtensions: ['ts', 'tsx', 'js', 'jsx', 'json', 'node'], // Ekstensi file yang dikenali oleh Jest
  testMatch: ['**/src/**/*.test.ts'], // Menentukan pola file tes, di sini tes berada di dalam folder `src` dan memiliki ekstensi `.test.ts`
};
