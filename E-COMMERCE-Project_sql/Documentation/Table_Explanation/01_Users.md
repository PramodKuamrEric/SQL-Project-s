![Users-Table-images](Tables-image/Users.png)


English Explanation


```sql
CREATE TABLE users (

```

This line tells MySQL to create a new table named **`users`**. Whatever columns are defined inside this will make up the structure of the table.

---

```sql
user_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,

```

* **`user_id`** — The name of the column, used to uniquely identify each user.
* **`BIGINT`** — A data type used to store large integers (since there could potentially be a massive number of users, `BIGINT` is used instead of a standard `INT`).
* **`UNSIGNED`** — Only allows positive numbers (a negative `user_id` doesn't make sense), which effectively doubles the maximum limit of the range.
* **`AUTO_INCREMENT`** — Every time a new row is inserted, MySQL will automatically increment this column's value (1, 2, 3...). You don't need to provide this value manually.
* **`PRIMARY KEY`** — The main unique identifier for this table. This means no two rows can have the same `user_id`, and this column can never be `NULL`.

---

```sql
first_name VARCHAR(100) NOT NULL,
last_name  VARCHAR(100) NOT NULL,

```

* **`VARCHAR(100)`** — Variable-length text, up to a maximum of 100 characters.
* **`NOT NULL`** — This column cannot be left empty (blank/NULL); providing a value is mandatory.

---

```sql
email VARCHAR(255) NOT NULL UNIQUE,

```

* **`VARCHAR(255)`** — The standard length of 255 characters for emails (ensuring long email addresses can be accommodated).
* **`NOT NULL`** — Providing an email is mandatory.
* **`UNIQUE`** — No two users can register with the exact same email. This is essential for login and authentication.

---

```sql
password_hash VARCHAR(255) NOT NULL,

```

* Passwords are never stored in plain text — they are always stored as a **hash** (an encrypted format, like bcrypt) for security purposes.
* `255` characters is spacious enough to accommodate longer hash algorithms (like bcrypt or argon2).

---

```sql
phone VARCHAR(20),

```

* The phone number is stored as text rather than a number type because phone numbers can include characters like `+91`, spaces, or leading zeros, which would be lost in an integer format.
* Since `NOT NULL` is absent, this is an **optional field** — the user can choose to leave it blank.

---

```sql
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

```

* Whenever a new user account is created, this column automatically captures the current date and time (`DEFAULT CURRENT_TIMESTAMP` means if you don't provide a value, MySQL will insert the exact current time by default).
* This helps you track exactly when the user registered.

---

**Summary in one line:**
This statement creates a `users` table where every user has a unique auto-generated ID; name, email, and password are mandatory; the phone number is optional; the account creation time is automatically recorded; there is an index on the email for faster searching; and it uses the InnoDB engine so that foreign keys and transactions work safely.







Hinglish Explanation



```sql
CREATE TABLE users (
```
Yeh line MySQL ko bolti hai ki ek naya table banao jiska naam **`users`** hai. Iske andar jo bhi columns define honge, wo is table ke structure banayenge.

---

```sql
user_id BIGINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
```
- **`user_id`** — column ka naam, har user ko uniquely identify karne ke liye.
- **`BIGINT`** — bada integer number store karne ke liye data type (bahut zyada users ho sakte hain, isliye `INT` ke bajaye `BIGINT` use kiya).
- **`UNSIGNED`** — sirf positive numbers allow karta hai (negative user_id ka koi matlab nahi hota), isse range aur bhi badh jaati hai.
- **`AUTO_INCREMENT`** — har naye row insert hone par MySQL khud-ba-khud is column ki value ko 1, 2, 3... badhata jaayega. Aapko manually value dene ki zaroorat nahi.
- **`PRIMARY KEY`** — is table ka main unique identifier. Iska matlab: koi bhi do rows ka `user_id` same nahi ho sakta, aur yeh column kabhi `NULL` nahi ho sakta.

---

```sql
first_name VARCHAR(100) NOT NULL,
last_name  VARCHAR(100) NOT NULL,
```
- **`VARCHAR(100)`** — variable-length text, max 100 characters tak.
- **`NOT NULL`** — is column ko empty (blank/NULL) nahi chhod sakte, value dena compulsory hai.

---

```sql
email VARCHAR(255) NOT NULL UNIQUE,
```
- **`VARCHAR(255)`** — email ke liye 255 characters ka standard length (long emails bhi accommodate ho jaate hain).
- **`NOT NULL`** — email dena zaroori hai.
- **`UNIQUE`** — koi bhi do users same email se register nahi kar sakte. Yeh login/authentication ke liye zaroori hai.

---

```sql
password_hash VARCHAR(255) NOT NULL,
```
- Password kabhi bhi plain text me store nahi karte — hamesha **hash** (encrypted form, jaise bcrypt) store hota hai security ke liye.
- `255` characters lambe hash algorithms (jaise bcrypt/argon2) ko accommodate karne ke liye kaafi hai.

---

```sql
phone VARCHAR(20),
```
- Phone number text ke roop me store kiya (number type nahi), kyunki phone numbers me `+91`, spaces, ya leading zeros ho sakte hain jo integer me preserve nahi hote.
- Yahan `NOT NULL` nahi likha, matlab **optional field hai** — user chahe to na bhare.

---

```sql
created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
```
- Jab bhi naya user account create hota hai, yeh column automatically current date-time capture kar leta hai (`DEFAULT CURRENT_TIMESTAMP` ka matlab — agar aap value nahi doge, to MySQL khud abhi ka time daal dega).
- Isse aapko pata chalta hai user kab register hua tha.

---



**Summary ek line me:** Yeh statement ek `users` table banata hai jisme har user ka ek unique auto-generated ID hota hai, naam/email/password compulsory hai, phone optional hai, account creation time automatically record hota hai, email par fast search ke liye index laga hai, aur InnoDB engine use hota hai taaki foreign keys aur transactions safely kaam kar sakein.







