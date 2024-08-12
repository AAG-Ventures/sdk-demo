import * as React from 'react';
import { StyleSheet, View, Text } from 'react-native';
import {
  type Wallets,
  type ColorsScheme,
  getWallets,
  sendTransaction,
} from '@aag-development/react-native-metaone-wallet-sdk';
import useColorsAwareObject from '../hooks/useColorsAwareObject';
import { Container } from '../components/Container';
import DropDownPicker from 'react-native-dropdown-picker';
import { useToast } from 'react-native-toast-notifications';
import CustomButton from '../components/Button/CustomButton';
import Input from '../components/Input';




const SendCustomTransactionScreen: React.FC = () => {
  const styles = useColorsAwareObject(screenStyles);
  const toast = useToast();
  const [walletId, setWalletId] = React.useState<string | null>(null);
  const [selectedAssetRef, setSelectedAssetRef] = React.useState<string | null>(null);

  const [address, setAddress] = React.useState<string | undefined>();
  const [amount, setAmount] = React.useState<string | undefined>();
  const [personalNote, setPersonalNote] = React.useState<string | undefined>();

  const [visibleWalletPicker, setVisibleWalletPicker] = React.useState<boolean>(false);
  const [visibleAssetPicker, setVisibleAssetPicker] = React.useState<boolean>(false);

  const [wallets, setWallets] = React.useState<Wallets.UserWallet[]>([]);
  const [loading, setLoading] = React.useState<boolean>(false);

  React.useEffect(() => {
    const fetchWallets = async () => {
      const result = await getWallets()
      setWallets(result.wallets)
    }
    fetchWallets()
  }, [])


  const onSelectWallet = ({ value: changed }: any) => {
    if (changed !== walletId) {
      setSelectedAssetRef(null)
    }
  };

  const generateAssetId = (token: Wallets.Token) => {
    return `${token.assetRef}-${token.currencyName}-${token.currencySymbol}`
  }

  const selectedWallet = React.useMemo(() => (wallets.find(i => i._id === walletId)), [wallets, walletId])
  const tokens = React.useMemo(() => (selectedWallet?.tokens || []), [selectedWallet])
  const walletsList = React.useMemo(() => (wallets.map(i => ({ label: `${i.name} (${i.currencySymbol}) - ${i.balance.substring(0, 8)}`, value: i._id }))), [wallets])
  const tokensList = React.useMemo(() => ([{ label: `${selectedWallet?.currencyName} (${selectedWallet?.currencySymbol}) - ${selectedWallet?.balance.substring(0, 8)}`, value: "0" }, ...tokens.map(i => ({ label: `${i.currencyName} (${i.currencySymbol}) - ${i.balance.substring(0, 8)}`, value: generateAssetId(i) }))]), [tokens, selectedWallet])
  const isCanContinue = selectedWallet && amount && address

  const onSubmit = () => {
    const selectedAsset = tokens.find(i => generateAssetId(i) === selectedAssetRef)
    setLoading(true)
    sendTransaction(selectedWallet!, address!, amount!, selectedAsset, "", personalNote).then(response => {
      setLoading(false)
      if (response == true) {
        toast.show('Transaction successfully signed and sent', { type: 'success' });
      } else {
        toast.show('Transaction failed', { type: 'warning' });
      }
    }).catch(e => {
      console.log("sendTransaction", e)
      setLoading(false)
      toast.show('Transaction failed', { type: 'warning' });
    })
  };

  return (
    <Container>
      <View style={styles.head}>
        <Text style={styles.label}>Sign currency send transaction</Text>
      </View>
      <View style={styles.wrapper}>
        <DropDownPicker
          open={visibleWalletPicker}
          setOpen={setVisibleWalletPicker}
          value={walletId}
          setValue={setWalletId}
          items={walletsList}
          placeholder={'Select Wallet'}
          onSelectItem={onSelectWallet}
        />
        {
          tokensList.length > 1 && (
            <DropDownPicker
              open={visibleAssetPicker}
              setOpen={setVisibleAssetPicker}
              value={selectedAssetRef}
              setValue={setSelectedAssetRef}
              items={tokensList}
              placeholder={'Select Asset'}
              onSelectItem={onSelectWallet}
            />
          )
        }
        <Input
          placeholder="To Address:"
          value={address}
          onChangeText={setAddress}
        />
        <Input
          placeholder="Amount:"
          value={amount}
          onChangeText={setAmount}
        />
        <Input
          placeholder="Personal Note:"
          value={personalNote}
          onChangeText={setPersonalNote}
        />
        <CustomButton
          onPress={onSubmit}
          loading={loading}
          disabled={!isCanContinue}
          label='SIGN'
        />
      </View>
    </Container>
  );
};

const screenStyles = (colors: ColorsScheme) =>
  StyleSheet.create({
    label: {
      fontSize: 20,
      fontWeight: '700',
      color: colors.black,
      textAlign: 'center',
    },
    text: {
      color: colors.black,
    },
    head: {
      width: '100%',
      paddingVertical: 10,
    },
    wrapper: {
      flex: 1,
      width: '100%',
      gap: 15,
      padding: 20,
    },
  });

export default SendCustomTransactionScreen;
