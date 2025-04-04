# KSU-OfficeNode

KSU-OfficeNode is an automated data collection and processing pipeline that runs on a 
Linux-based machine (Machine A) at the Kennesaw State University field station office.
It manages coordination between:

    Machine A – Local Linux computer running TVWS DataScraper.

    Machine B – Raspberry Pi collecting soil moisture data.

    Machine C – CR5 data logger capturing atmospheric data.

- [TVWSDataScraper](https://github.com/StevenNaliwajka/TVWSDataScraper) - Machine A's Web scraper
- [KSU-TowerNode](https://github.com/StevenNaliwajka/KSU-TowerNode) - Machine B's Logic

The pipeline handles daily automation tasks such as device coordination, 
data pulling, archiving, and web scraping — with a built-in boot-to-boot cycle.