// BACKEND SETUP GUIDE for CivicShield
//
// This is a sample Node.js/Express backend for authentication
// Setup instructions are provided below
//
// ============================================
// INSTALLATION & SETUP
// ============================================
//
// 1. Create a new directory for the backend:
//    mkdir civicshield-backend
//    cd civicshield-backend
//
// 2. Initialize a new Node.js project:
//    npm init -y
//
// 3. Install dependencies:
//    npm install express cors dotenv bcryptjs jsonwebtoken
//    npm install --save-dev nodemon
//
// 4. Create a .env file with:
//    PORT=3000
//    JWT_SECRET=your_secret_key_here
//    DATABASE_URL=your_database_url
//
// 5. Create server.js with the code below
//
// 6. Update package.json scripts:
//    "start": "node server.js",
//    "dev": "nodemon server.js"
//
// 7. Run the server:
//    npm run dev
//
// ============================================
// SAMPLE NODE.JS/EXPRESS BACKEND
// ============================================

const express = require('express');
const cors = require('cors');
const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
require('dotenv').config();

const app = express();
const PORT = process.env.PORT || 3000;

// Middleware
app.use(cors());
app.use(express.json());

// Mock database (replace with real database in production)
const users = new Map();
let userIdCounter = 1;

// Utility functions
const generateToken = (userId) => {
  return jwt.sign({ userId }, process.env.JWT_SECRET || 'secret_key', {
    expiresIn: '7d',
  });
};

const verifyToken = (token) => {
  try {
    return jwt.verify(token, process.env.JWT_SECRET || 'secret_key');
  } catch (error) {
    return null;
  }
};

const hashPassword = async (password) => {
  const salt = await bcrypt.genSalt(10);
  return bcrypt.hash(password, salt);
};

const comparePassword = async (password, hashedPassword) => {
  return bcrypt.compare(password, hashedPassword);
};

// Health check endpoint
app.get('/api/health', (req, res) => {
  res.json({ status: 'Backend is online' });
});

// SIGNUP endpoint
app.post('/api/auth/signup', async (req, res) => {
  try {
    const { name, phone, email, password } = req.body;

    // Validation
    if (!name || !phone || !email || !password) {
      return res.status(400).json({
        success: false,
        message: 'All fields are required',
      });
    }

    // Check if user already exists
    const existingUser = Array.from(users.values()).find(
      (u) => u.phone === phone || u.email === email
    );

    if (existingUser) {
      return res.status(400).json({
        success: false,
        message: 'User with this phone or email already exists',
      });
    }

    // Hash password
    const hashedPassword = await hashPassword(password);

    // Create user
    const userId = `user_${userIdCounter++}`;
    const newUser = {
      id: userId,
      name,
      phone,
      email,
      password: hashedPassword,
      createdAt: new Date().toISOString(),
    };

    users.set(userId, newUser);

    // Generate token
    const token = generateToken(userId);

    // Return response (exclude password)
    res.status(201).json({
      success: true,
      message: 'User registered successfully',
      user: {
        id: newUser.id,
        name: newUser.name,
        phone: newUser.phone,
        email: newUser.email,
        createdAt: newUser.createdAt,
      },
      token,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Server error: ' + error.message,
    });
  }
});

// LOGIN endpoint
app.post('/api/auth/login', async (req, res) => {
  try {
    const { phone, password } = req.body;

    // Validation
    if (!phone || !password) {
      return res.status(400).json({
        success: false,
        message: 'Phone and password are required',
      });
    }

    // Find user
    const user = Array.from(users.values()).find((u) => u.phone === phone);

    if (!user) {
      return res.status(401).json({
        success: false,
        message: 'Invalid phone or password',
      });
    }

    // Check password
    const isPasswordValid = await comparePassword(password, user.password);

    if (!isPasswordValid) {
      return res.status(401).json({
        success: false,
        message: 'Invalid phone or password',
      });
    }

    // Generate token
    const token = generateToken(user.id);

    // Return response (exclude password)
    res.status(200).json({
      success: true,
      message: 'Login successful',
      user: {
        id: user.id,
        name: user.name,
        phone: user.phone,
        email: user.email,
        createdAt: user.createdAt,
      },
      token,
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Server error: ' + error.message,
    });
  }
});

// VERIFY TOKEN endpoint
app.post('/api/auth/verify', (req, res) => {
  try {
    const token = req.headers.authorization?.replace('Bearer ', '');

    if (!token) {
      return res.status(401).json({
        success: false,
        message: 'Token not provided',
      });
    }

    const decoded = verifyToken(token);

    if (!decoded) {
      return res.status(401).json({
        success: false,
        message: 'Invalid or expired token',
      });
    }

    res.status(200).json({
      success: true,
      message: 'Token is valid',
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Server error: ' + error.message,
    });
  }
});

// GET PROFILE endpoint
app.get('/api/auth/profile', (req, res) => {
  try {
    const token = req.headers.authorization?.replace('Bearer ', '');

    if (!token) {
      return res.status(401).json({
        success: false,
        message: 'Token not provided',
      });
    }

    const decoded = verifyToken(token);

    if (!decoded) {
      return res.status(401).json({
        success: false,
        message: 'Invalid or expired token',
      });
    }

    const user = users.get(decoded.userId);

    if (!user) {
      return res.status(404).json({
        success: false,
        message: 'User not found',
      });
    }

    res.status(200).json({
      success: true,
      message: 'Profile fetched successfully',
      user: {
        id: user.id,
        name: user.name,
        phone: user.phone,
        email: user.email,
        createdAt: user.createdAt,
      },
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Server error: ' + error.message,
    });
  }
});

// LOGOUT endpoint
app.post('/api/auth/logout', (req, res) => {
  try {
    // In production, you'd invalidate the token in a database
    // For now, just return success
    res.status(200).json({
      success: true,
      message: 'Logout successful',
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Server error: ' + error.message,
    });
  }
});

// REQUEST PASSWORD RESET endpoint
app.post('/api/auth/request-reset', (req, res) => {
  try {
    const { phone } = req.body;

    if (!phone) {
      return res.status(400).json({
        success: false,
        message: 'Phone is required',
      });
    }

    const user = Array.from(users.values()).find((u) => u.phone === phone);

    if (!user) {
      // Don't reveal if user exists for security
      return res.status(200).json({
        success: true,
        message: 'If user exists, password reset link has been sent',
      });
    }

    // In production, send an email/SMS with reset link
    res.status(200).json({
      success: true,
      message: 'Password reset link has been sent',
    });
  } catch (error) {
    res.status(500).json({
      success: false,
      message: 'Server error: ' + error.message,
    });
  }
});

// Start server
app.listen(PORT, () => {
  console.log(`✓ CivicShield Backend running on http://localhost:${PORT}`);
  console.log(`✓ API Health: http://localhost:${PORT}/api/health`);
});

// Export for testing
module.exports = app;
