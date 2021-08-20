const Encrypter = require('./hash_try');

const encrypter = new Encrypter("secret");

// const clearText = "adventure time";
// const encrypted = encrypter.encrypt(clearText);
// console.log(encrypted);
 try {
   const dec=  encrypter.decrypt('a14cce25f6748997c313fc756b733965|24bd43899d4fb928da433ad903240037');
    console.log(dec);
} catch (error) {
    console.log('hey');
} 
// console.log(dencrypted);
