-- Migration script: Convert premium_points to znote standard points
-- This script migrates the server from using 'premium_points' to the znote standard 'points' in znote_accounts table

-- The znote_accounts table already has 'points' column and references account_id from accounts table
-- No schema changes needed - the table structure is already correct

-- Step 1: Ensure znote_accounts entries exist for all accounts (if needed)
-- Run this if you don't have znote_accounts entries for existing accounts:
-- INSERT INTO `znote_accounts` (`account_id`, `ip`, `created`, `points`, `flag`, `secret`)
-- SELECT `id`, 0, UNIX_TIMESTAMP(), 0, '', NULL FROM `accounts` 
-- WHERE `id` NOT IN (SELECT `account_id` FROM `znote_accounts`);

-- Step 2: Migrate points from old premium_points column if it existed in accounts table (optional)
-- UPDATE `znote_accounts` SET `points` = (
--   SELECT `premium_points` FROM `accounts` WHERE `accounts`.`id` = `znote_accounts`.`account_id`
-- ) WHERE EXISTS (
--   SELECT 1 FROM `accounts` WHERE `accounts`.`id` = `znote_accounts`.`account_id`
-- );

-- After running this migration:
-- 1. Rebuild the C++ server (code updated to use znote_accounts.points)
-- 2. All Lua scripts already updated to use znote_accounts.points
-- 3. Test the store and premium point system thoroughly
