#!/usr/bin/env node

const { spawn } = require('child_process');
const path = require('path');
const fs = require('fs').promises;
const os = require('os');

const [environment, platform, threadsArg] = process.argv.slice(2);
const maxThreads = parseInt(threadsArg) || os.cpus().length;

async function findTestFiles() {
    const testDir = path.join(__dirname, '../tests');
    const files = [];
    
    async function scan(dir) {
        const entries = await fs.readdir(dir, { withFileTypes: true });
        for (const entry of entries) {
            const fullPath = path.join(dir, entry.name);
            if (entry.isDirectory()) {
                await scan(fullPath);
            } else if (entry.name.endsWith('.yaml') && !entry.name.startsWith('utils') && !entry.name.startsWith('screenshots')) {
                files.push(fullPath);
            }
        }
    }
    
    await scan(testDir);
    return files;
}

async function runTest(testFile) {
    const testName = path.basename(testFile, '.yaml');
    console.log(`Running test: ${testName}`);
    
    return new Promise((resolve, reject) => {
        const proc = spawn('maestro', [
            'test',
            '--env', `APP_ID=${platform === 'android' ? 'com.testsquad.myapp' : 'com.testsquad.myapp.ios'}`,
            '--env', `TEST_NAME=${testName}`,
            '--format', 'allure',
            testFile
        ], { stdio: 'inherit' });

        proc.on('close', (code) => {
            if (code === 0) {
                resolve();
            } else {
                reject(new Error(`Test failed: ${testFile}`));
            }
        });
    });
}

async function runTestsInParallel() {
    const testFiles = await findTestFiles();
    const chunks = [];
    
    for (let i = 0; i < testFiles.length; i += maxThreads) {
        chunks.push(testFiles.slice(i, i + maxThreads));
    }
    
    for (const chunk of chunks) {
        await Promise.all(chunk.map(testFile => runTest(testFile)));
    }
}

console.log(`🚀 Starting parallel test execution with ${maxThreads} threads`);
runTestsInParallel().catch(console.error); 