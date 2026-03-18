// server.js - 简单的后端服务器
const express = require('express');
const admin = require('firebase-admin');
const { verifyReceipt } = require('apple-receipt-verify');

const app = express();
app.use(express.json());

// 初始化 Firebase Admin
admin.initializeApp({
  credential: admin.credential.applicationDefault(),
});

const db = admin.firestore();

// 验证 Apple 收据并更新用户状态
app.post('/verify-purchase', async (req, res) => {
  const { userId, receiptData } = req.body;

  try {
    // 验证 Apple 收据
    const receipt = await verifyReceipt({
      receiptData,
      password: 'your_app_shared_secret',
      excludeOldTransactions: true,
    });

    if (receipt.status === 0 && receipt.latestReceiptInfo) {
      // 收据有效，更新用户为付费用户
      await db.collection('users').doc(userId).set({
        isPremium: true,
        purchaseDate: admin.firestore.FieldValue.serverTimestamp(),
        receiptData: receiptData,
      }, { merge: true });

      res.json({ success: true, isPremium: true });
    } else {
      res.status(400).json({ success: false, message: '收据无效' });
    }
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
});

// 检查使用权限并增加使用次数
app.post('/check-and-use', async (req, res) => {
  const { userId, deviceId } = req.body;

  try {
    const userDoc = await db.collection('users').doc(userId).get();
    const userData = userDoc.data() || {};

    // 检查是否为付费用户
    if (userData.isPremium) {
      return res.json({ canUse: true, remaining: -1 });
    }

    // 检查免费使用次数
    const today = new Date().toDateString();
    const usageRef = db.collection('usage').doc(`${userId}_${today}`);
    const usageDoc = await usageRef.get();

    let usageCount = 0;
    if (usageDoc.exists) {
      usageCount = usageDoc.data().count || 0;
    }

    // 免费用户限制 10 次
    if (usageCount >= 10) {
      return res.json({ canUse: false, remaining: 0 });
    }

    // 增加使用次数
    await usageRef.set({
      count: usageCount + 1,
      deviceId: deviceId,
      timestamp: admin.firestore.FieldValue.serverTimestamp(),
    }, { merge: true });

    res.json({
      canUse: true,
      remaining: 10 - usageCount - 1,
      usageCount: usageCount + 1
    });
  } catch (error) {
    res.status(500).json({ success: false, message: error.message });
  }
});

// 生成壁纸（API Key 在服务器）
app.post('/generate-wallpaper', async (req, res) => {
  const { userId, description } = req.body;

  try {
    // 检查用户权限
    const userDoc = await db.collection('users').doc(userId).get();
    const userData = userDoc.data();

    if (!userData || (!userData.isPremium && userData.usageCount >= 10)) {
      return res.status(403).json({ error: '无权限或使用次数已用完' });
    }

    // 调用 AI API（API Key 安全存储在服务器）
    const response = await fetch('https://api.example.com/v1/images/generations', {
      method: 'POST',
      headers: {
        'Authorization': `Bearer ${process.env.IMAGE_API_KEY}`, // 环境变量
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        model: 'glm-image',
        prompt: description,
        size: '1280x1280',
      }),
    });

    const result = await response.json();
    res.json(result);
  } catch (error) {
    res.status(500).json({ error: error.message });
  }
});

const PORT = process.env.PORT || 3000;
app.listen(PORT, () => {
  console.log(`服务器运行在端口 ${PORT}`);
});
