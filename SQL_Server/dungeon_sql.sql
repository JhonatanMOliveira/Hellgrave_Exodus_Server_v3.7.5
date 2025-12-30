CREATE TABLE `solo_runners` (
  `player_id` int(11) NOT NULL,
  `dungeon_id` smallint(6) NOT NULL,
  `difficulty` tinyint(4) NOT NULL,
  `time` mediumint(8) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `group_runners` (
  `run_id` int(10) UNSIGNED NOT NULL,
  `player` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

CREATE TABLE `group_runs` (
  `id` int(10) UNSIGNED NOT NULL,
  `dungeon_id` smallint(6) NOT NULL,
  `difficulty` tinyint(4) NOT NULL,
  `time` mediumint(8) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- Indexes for table `group_runners`
--
ALTER TABLE `group_runners`
  ADD KEY `run_id` (`run_id`);

--
-- Indexes for table `group_runs`
--
ALTER TABLE `group_runs`
  ADD PRIMARY KEY (`id`);

-- Indexes for table `solo_runners`
--
ALTER TABLE `solo_runners`
  ADD KEY `player_id` (`player_id`);

-- Constraints for table `group_runners`
--
ALTER TABLE `group_runners`
  ADD CONSTRAINT `group_runners_ibfk_1` FOREIGN KEY (`run_id`) REFERENCES `group_runs` (`id`) ON DELETE CASCADE;

-- Constraints for table `solo_runners`
--
ALTER TABLE `solo_runners`
  ADD CONSTRAINT `solo_runners_ibfk_1` FOREIGN KEY (`player_id`) REFERENCES `players` (`id`) ON DELETE CASCADE;