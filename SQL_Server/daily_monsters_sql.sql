SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";

CREATE TABLE `daily_monsters` (
  `name` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `multiplier_damage` int(11) NOT NULL DEFAULT 0,
  `multiplier_health` int(11) NOT NULL DEFAULT 0,
  `multiplier_experience` int(11) NOT NULL DEFAULT 0,
  `multiplier_loot` int(11) NOT NULL DEFAULT 0,
  `multiplier_spawn` int(11) NOT NULL DEFAULT 0
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;
COMMIT;