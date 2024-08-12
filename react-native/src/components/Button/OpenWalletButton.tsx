import React from 'react';
import {Button} from 'react-native';
import {openWallet} from '@aag-development/react-native-metaone-wallet-sdk';

type OpenSettingsButtonProps = {
  title: string;
  disabled?: boolean;
};

export const OpenWalletButton = ({title, disabled}: OpenSettingsButtonProps) => {
  const handleOpenWallet = async () => {
    try {
      await openWallet();
    } catch (error) {
      console.log(error);
    }
  };
  return (
    <Button title={title} onPress={handleOpenWallet} disabled={disabled} />
  );
};
