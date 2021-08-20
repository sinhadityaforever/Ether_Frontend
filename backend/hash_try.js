const crypto = require("crypto");
<<<<<<< HEAD

class Encrypter {
  constructor(encryptionKey) {
    this.algorithm = "aes-192-cbc";
    this.key = crypto.scryptSync(encryptionKey, "salt", 24);
  }

  encrypt(clearText) {
    const iv = crypto.randomBytes(16);
    const cipher = crypto.createCipheriv(this.algorithm, this.key, iv);
    const encrypted = cipher.update(clearText, "utf8", "hex");
    return [
      encrypted + cipher.final("hex"),
      Buffer.from(iv).toString("hex"),
    ].join("|");
  }

  decrypt(encryptedText) {
    const [encrypted, iv] = encryptedText.split("|");
    if (!iv) throw new Error("IV not found");
    const decipher = crypto.createDecipheriv(
      this.algorithm,
      this.key,
      Buffer.from(iv, "hex")
    );
    return decipher.update(encrypted, "hex", "utf8") + decipher.final("utf8");
  }
}

module.exports=Encrypter;

// const encrypter = new Encrypter("secret");

// const clearText = "adventure time";
// const encrypted = encrypter.encrypt(clearText);
// // console.log(encrypted);
// const dencrypted = encrypter.decrypt('a14cce25f6748997c313fc756b733965|24bd43899d4fb928da433ad903240037');
// console.log(dencrypted);


=======
const algorithm = "aes-256-cbc";
const key = crypto.randomBytes(32);
const iv = crypto.randomBytes(16);

function encrypt(text) {
    let cipher = crypto.createCipheriv("aes-256-cbc", Buffer.from(key), iv);
    let encrypted = cipher.update(text);
    encrypted = Buffer.concat([encrypted, cipher.final()]);
    return { iv: iv.toString("hex"), encryptedData: encrypted.toString("hex") };
}

function decrypt(ivO, encryptedData) {
    let iv = Buffer.from(ivO, "hex");
    let encryptedText = Buffer.from(encryptedData, "hex");
    let decipher = crypto
        .createDecipheriv("aes-256-cbc", Buffer.from(key), iv)
        .setAutoPadding(false);
    let decrypted = decipher.update(encryptedText);
    decrypted = Buffer.concat([decrypted, decipher.final()]);
    return decrypted.toString();
}

// var hw = encrypt("So how are you?")
// console.log(hw)
console.log(
    decrypt(
        "bbda614cf95bf20f63a005c2badfb5bf",
        "7196d78adde827d217586be2b5fcbd8d"
    )
);
>>>>>>> a17d1de60093989744e629f43d85dcabb3c68504
