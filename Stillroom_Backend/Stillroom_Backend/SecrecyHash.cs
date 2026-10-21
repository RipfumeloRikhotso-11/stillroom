using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Web;

namespace Stillroom_Backend
{
    public class SecrecyHash
    {
        // Hash a password when a user registers.
        public static string hashFunction(string password)
        {
            byte[] salt = new byte[16];

            using (var rng = RandomNumberGenerator.Create())
            {
                rng.GetBytes(salt);
            }

            const int iterations = 210000;
            byte[] hash;

            using (var pbkdf2 = new Rfc2898DeriveBytes(
                password, salt, iterations))
            {
                hash = pbkdf2.GetBytes(32);
            }

            return iterations + ":" +
                   Convert.ToBase64String(salt) + ":" +
                   Convert.ToBase64String(hash);
        }

        // Verify the password when a user logs in.
        public static bool verifyPassword(
            string password, string storedHash)
        {
            if (string.IsNullOrEmpty(password) ||
                string.IsNullOrEmpty(storedHash))
                return false;

            string[] parts = storedHash.Split(':');

            if (parts.Length != 3)
                return false;

            int iterations;

            if (!int.TryParse(parts[0], out iterations) ||
                iterations < 100000 || iterations > 1000000)
                return false;

            try
            {
                byte[] salt =
                    Convert.FromBase64String(parts[1]);

                byte[] expectedHash =
                    Convert.FromBase64String(parts[2]);

                if (salt.Length != 16 || expectedHash.Length != 32)
                    return false;

                byte[] actualHash;

                using (var pbkdf2 = new Rfc2898DeriveBytes(
                    password, salt, iterations))
                {
                    actualHash = pbkdf2.GetBytes(32);
                }

                int difference = 0;

                for (int i = 0; i < actualHash.Length; i++)
                {
                    difference |= actualHash[i] ^ expectedHash[i];
                }

                return difference == 0;
            }
            catch (FormatException)
            {
                return false;
            }
        }
    }
}