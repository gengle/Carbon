﻿using System.Collections.Generic;

namespace Carbon
{
	public sealed class ScheduledTaskInfo
	{
		public ScheduledTaskInfo(string hostName, string path, string name, string nextRunTime, string status, string logonMode,
			string lastRunTime, string author, string taskToRun, string startIn, string comment, string scheduledTaskState,
			string idleTime, string powerManagement, string runAsUser, string deleteTaskIfNotRescheduled)
		{
			HostName = hostName;
			TaskPath = path;
			TaskName = name;
			NextRunTime = nextRunTime;
			Status = status;
			LogonMode = logonMode;
			LastRunTime = lastRunTime;
			Author = author;
			TaskToRun = taskToRun;
			StartIn = startIn;
			Comment = comment;
			ScheduledTaskState = scheduledTaskState;
			IdleTime = idleTime;
			PowerManagement = powerManagement;
			RunAsUser = runAsUser;
			DeleteTaskIfNotRescheduled = deleteTaskIfNotRescheduled;

			Schedules = new List<ScheduledTaskScheduleInfo>();
		}

		public string Author { get; private set; }
		public string Comment { get; private set; }
		public string DeleteTaskIfNotRescheduled { get; private set; }
		public string HostName { get; private set; }
		public string IdleTime { get; private set; }
		public string LastRunTime { get; private set; }
		public string LogonMode { get; private set; }
		public string NextRunTime { get; private set; }
		public string PowerManagement { get; private set; }
		public string RunAsUser { get; private set; }
		public IList<ScheduledTaskScheduleInfo> Schedules { get; private set; }
		public string ScheduledTaskState { get; private set; }
		public string StartIn { get; private set; }
		public string Status { get; private set; }
		public string TaskToRun { get; private set; }
		public string TaskName { get; private set; }
		public string TaskPath { get; private set; }
	}
}