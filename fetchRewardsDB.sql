CREATE DATABASE fetch_rewards;

USE fetch_rewards;


CREATE TABLE brands (
    brandId VARCHAR(225) PRIMARY KEY,
    barcode INT,
    categoryCode VARCHAR(255),
    category VARCHAR(255),
    topBrand BOOLEAN,
    name VARCHAR(255),
    ref VARCHAR(255),
    cpgId VARCHAR(255),
    brandCode VARCHAR(255),
    UNIQUE (cpgId)
);

CREATE TABLE receipts (
    receiptId VARCHAR(255) PRIMARY KEY,
    rewardsReceiptStatus VARCHAR(255),
    bonusPointsEarnedReason VARCHAR(255)
);

CREATE TABLE users (
    userId VARCHAR(255) PRIMARY KEY,
    createdDate DATETIME,
    lastLogin DATETIME,
    role VARCHAR(255),
    active BOOLEAN,
    signUpSource VARCHAR(255),
    state VARCHAR(255)
);

CREATE TABLE dates (
    dateId INT AUTO_INCREMENT PRIMARY KEY,
    date DATE,
    day INT,
    month INT,
    year INT,
    quarter INT
);

CREATE TABLE points (
    receiptId VARCHAR(255),
    userId VARCHAR(255),
    createdDateId INT,
    dateScannedId INT,
    finishedDateId INT,
    modifyDateId INT,
    pointsAwardedDateId INT,
    purchaseDateId INT,
    bonusPointsEarned DECIMAL(10,2),
    pointsEarned DECIMAL(10,2),
    purchaseItemCount DECIMAL(10,2),
    totalSpent DECIMAL(10, 2),
    PRIMARY KEY (receiptId, userId),
    FOREIGN KEY (receiptId) REFERENCES receipts(receiptId),
    FOREIGN KEY (createdDateId) REFERENCES dates(dateId),
    FOREIGN KEY (dateScannedId) REFERENCES dates(dateId),
    FOREIGN KEY (finishedDateId) REFERENCES dates(dateId),
    FOREIGN KEY (modifyDateId) REFERENCES dates(dateId),
    FOREIGN KEY (pointsAwardedDateId) REFERENCES dates(dateId),
    FOREIGN KEY (purchaseDateId) REFERENCES dates(dateId),
    FOREIGN KEY (userId) REFERENCES users(userId)
);


CREATE TABLE itemslist (
    receiptId VARCHAR(255),
    barcode VARCHAR(255),
    description VARCHAR(255),
    finalPrice DECIMAL(10, 2),
    itemPrice DECIMAL(10, 2),
    needsFetchReview BOOLEAN,
    partnerItemId INT,
    preventTargetGapPoints BOOLEAN,
    quantityPurchased DECIMAL(10, 2),
    userFlaggedBarcode INT,
    userFlaggedNewItem BOOLEAN,
    userFlaggedPrice DECIMAL(10, 2),
    userFlaggedQuantity DECIMAL(10, 2),
    needsFetchReviewReason VARCHAR(255),
    pointsNotAwardedReason VARCHAR(255),
    pointsPayerId VARCHAR(255),
    rewardsGroup VARCHAR(255),
    rewardsProductPartnerId VARCHAR(255),
    userFlaggedDescription VARCHAR(255),
    originalMetaBriteBarcode INT,
    originalMetaBriteDescription VARCHAR(255),
    competitorRewardsGroup VARCHAR(255),
    discountedItemPrice DECIMAL(10, 2),
    originalReceiptItemText VARCHAR(255),
    itemNumber INT,
    originalMetaBriteQuantityPurchased DECIMAL(10, 2),
    pointsEarned DECIMAL(10, 2),
    targetPrice DECIMAL(10, 2),
    competitiveProduct BOOLEAN,
    originalFinalPrice DECIMAL(10, 2),
    originalMetaBriteItemPrice INT,
    deleted BOOLEAN,
    priceAfterCoupon DECIMAL(10, 2),
    metaBriteCampaignId VARCHAR(255),
    PRIMARY KEY (receiptId),
    FOREIGN KEY (receiptId) REFERENCES receipts(receiptId),
    FOREIGN KEY (rewardsProductPartnerId) REFERENCES brands(cpgId),
    UNIQUE (receiptId, barcode)
);




