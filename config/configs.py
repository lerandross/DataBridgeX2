from pydantic_settings import BaseSettings, SettingsConfigDict
from typing import ClassVar

class Settings(BaseSettings):
    API_GOOGLE_SHEETS: str

    MS_SQL_SERVER: str
    MS_SQL_USER: str
    MS_SQL_PASSWORD: str
    MS_SQL_PORT: int

    MYSQL_HOST: str
    MYSQL_USER: str
    MYSQL_PASSWORD: str
    MYSQL_PORT: int

    model_config = SettingsConfigDict(
        case_sensitive=True,
        env_file=".env",
        env_file_encoding="utf-8"
    )

settings: Settings = Settings()
